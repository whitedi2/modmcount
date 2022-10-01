﻿&НаСервере
Процедура ОтменитьОплату(Расшифровка, ОтменаОплаты, Комментарии)
	
	//у фиников нет прав для интерактивной отмены оплаты
	Если ПараметрыСеанса.ТекущийПользователь.Должность = Справочники.Д_Должности.Финансист Тогда
		Сообщить("Недостаточно прав.");
		Возврат;	
	КонецЕсли;
	
	Заявка = Расшифровка.Заявка.ПолучитьОбъект();
	
	
	ТекСтрока = Заявка.СЗ[Расшифровка.НомерСтроки - 1];
	
	//у стороннего рецензента нет прав для возврата отмены оплаты
	Если НЕ ПустаяСтрока(ТекСтрока.Рецензент) И НЕ ПараметрыСеанса.ТекущийПользователь = ТекСтрока.Рецензент И НЕ ПараметрыСеанса.ТекущийПользователь = Справочники.Пользователи.РуководительДКФ Тогда
		Сообщить("Невозможно вернуть пункт заявки, т.к. не Вы его отменили.");
		Возврат;	
	КонецЕсли;
	ТекСтрока.ОтменаОплаты = ОтменаОплаты;
	ТекСтрока.Рецензент = ?(ОтменаОплаты, ПараметрыСеанса.ТекущийПользователь, Справочники.Пользователи.ПустаяСсылка());
	ТекСтрока.Комментарии = Строка(Комментарии);
    Заявка.Записать(РежимЗаписиДокумента.Проведение);
	МассивЗаявки = Новый Массив;
	МассивЗаявки.Добавить(Расшифровка.Заявка);
	Документы.Д_СлужебнаяЗаписка.Печать(ТабДок, МассивЗаявки);
	//Документы.Д_ЗаявкаНаОплату.ПустаяСсылка().ЗаявкаБезнал.Получить(1).ОтменаОплаты
КонецПроцедуры
 


&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если ТипЗнч(Расшифровка) = Тип("Структура") Тогда
		Если Расшифровка.Свойство("Изменен") Тогда
			СтандартнаяОбработка = Ложь;
			ОткрытьФорму("Документ.Д_КорректировкаДокумента.Форма.ФормаСпискаПечать", Новый Структура("ДокОснование", Расшифровка.Корректировки) ); 
		ИначеЕсли Расшифровка.Свойство("ПечатьКомментариев") Тогда
			СтандартнаяОбработка = Ложь;
			ТабДок = Новый ТабличныйДокумент;
			Если Расшифровка.МассивОткрытыхИсторий = Неопределено Тогда
				Масс = Новый Массив;
			Иначе
				Масс = Расшифровка.МассивОткрытыхИсторий;	
			КонецЕсли;
			Если Расшифровка.ПечатьКомментариев Тогда
				Масс.Добавить(Расшифровка.РецензентКомментарий);
			Иначе
				Масс.Удалить(Масс.Найти(Расшифровка.РецензентКомментарий));
			КонецЕсли;
			ПечатьСКомментариями(ТабДок, Расшифровка.Ссылка, Расшифровка.РецензентКомментарий, Масс, Неопределено);
			ТабДок.ОтображатьСетку = Ложь;
			ТабДок.Защита = Ложь;
			ТабДок.ТолькоПросмотр = Истина;
			ТабДок.ОтображатьЗаголовки = Ложь;
			ФормаПечати = ЭтаФорма;
			ФормаПечати.ТабДок = ТабДок;
		ИначеЕсли Расшифровка.Свойство("ПечатьКомментариевАвтора") Тогда
			СтандартнаяОбработка = Ложь;
			ТабДок = Новый ТабличныйДокумент;
			Если Расшифровка.МассивОткрытыхИсторийАвтора = Неопределено Тогда
				МассивКомментариевАвтора = Новый Массив;
			Иначе
				МассивКомментариевАвтора = Расшифровка.МассивОткрытыхИсторийАвтора;	
			КонецЕсли;
			Если Расшифровка.ПечатьКомментариевАвтора Тогда
				МассивКомментариевАвтора.Добавить(Расшифровка.РецензентКомментарий);
			Иначе
				МассивКомментариевАвтора.Удалить(МассивКомментариевАвтора.Найти(Расшифровка.РецензентКомментарий));
			КонецЕсли;
			ПечатьСКомментариями(ТабДок, Расшифровка.Ссылка, , , МассивКомментариевАвтора);
			ТабДок.ОтображатьСетку = Ложь;
			ТабДок.Защита = Ложь;
			ТабДок.ТолькоПросмотр = Истина;
			ТабДок.ОтображатьЗаголовки = Ложь;
			ФормаПечати = ЭтаФорма;
			ФормаПечати.ТабДок = ТабДок;
		ИначеЕсли Расшифровка.Свойство("Файл") Тогда
			СтандартнаяОбработка = Ложь;
			ОткрытьЗначение(Расшифровка.Файл);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПечатьСервер(ТабДок, ПараметрКоманды) Экспорт
	Документы.Д_ЗаявкаНаОтгрузку.Печать(ТабДок, ПараметрКоманды);
	//Документы.Д_ЗаявкаНаОтгрузку.Печать(ТабДок, ПараметрКоманды);		
КонецПроцедуры


//&НаКлиенте
//Процедура СохранитьВPDF(Команда)
//	
//	Путь = БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ПолучитьПользователя(), "КаталогПользователя");
//	
//	Режим = РежимДиалогаВыбораФайла.Сохранение;
//	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
//	ТекДата = строка(ТекущаяДата());
//	
//	Если НЕ ПустаяСтрока(Путь) Тогда
//		ДиалогОткрытияФайла.ПолноеИмяФайла = Путь + "Заявка на оплату от " + ТекДата;
//	Иначе
//		ДиалогОткрытияФайла.ПолноеИмяФайла = "Заявка на оплату от " + ТекДата;	
//	КонецЕсли;
//	
//	Фильтр = "Файл PDF(*,pdf)|*.pdf";
//	ДиалогОткрытияФайла.Фильтр 			   = Фильтр;
//	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
//	ДиалогОткрытияФайла.Заголовок 		   = "Сохранить файл";
//	
//	Если ДиалогОткрытияФайла.Выбрать() Тогда
//		ПутьКФайлу = ДиалогОткрытияФайла.ПолноеИмяФайла;
//		ИмяФайла = "Заявка на оплату от " + ТекДата + ".pdf";
//		Состояние("Сохранение в формаре PDF в " + Строка(ПутьКФайлу) + ".");
//		БюджетныйНаКлиенте.СоздатьФайлPDF(ТабДок, ПутьКФайлу);
//		
//		//МойФайл = Новый ДвоичныеДанные(ПутьКФайлу);
//		//Размер = МойФайл.Размер();
//		//
//		//Если Размер > 2 * 1024 * 1024 Тогда
//		//	Предупреждение("Загрузка файлов размером более 2Мб невозможна.");
//		//	Возврат;			
//		//КонецЕсли;
//		//
//		//ФайлСсылка = БюджетныйНаСервере.ЗагрузитьИСоздатьЭлементФайл(ПутьКФайлу, "Заявка на оплату" + ТекДата);
//	КонецЕсли;
//	
//		
//КонецПроцедуры

//&НаКлиенте
//Процедура ОтправитьФайл(Команда)
//	Если ПустаяСтрока(ПутьКФайлу) Тогда
//		Если Вопрос("Вы не сохранили файл в формате PDF. Желаете сохранить файл?", РежимДиалогаВопрос.ДаНетОтмена) = КодВозвратаДиалога.Да  Тогда
//			СохранитьВPDF(0);
//			Возврат;
//		КонецЕсли; 	
//	КонецЕсли;
//	
//	Если ПустаяСтрока(БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ПолучитьПользователя(), "УчетнаяЗаписьЭлектроннойПочты")) Тогда
//		Предупреждение("Вы не имеете учетной записи электронной почты. Обратитесь к администратору для создания учетной записи.");
//		Возврат;	
//	КонецЕсли;
//	
//	ТекФайл = Новый Файл(ПутьКФайлу);
//	ТекРазмер = ТекФайл.Размер();
//	ПараметрыФормы = Новый Структура("Основание, ИмяФайла, ТекРазмер", ПутьКФайлу, ИмяФайла, ТекРазмер);
//	ОткрытьФорму("ОбщаяФорма.ОтправкаДанныхПоЭлектроннойПочте", ПараметрыФормы);
//КонецПроцедуры

&НаСервере
Процедура ПечатьСКомментариями(ТабДок, ПараметрКоманды, РецензентКомментарий, МассивОткрытыхИсторий, МассивОткрытыхИсторийАвтора)
	
	Документы.Д_ЗаявкаНаОтгрузку.Печать(ТабДок, ПараметрКоманды, РецензентКомментарий, МассивОткрытыхИсторий, МассивОткрытыхИсторийАвтора);
	
КонецПроцедуры

