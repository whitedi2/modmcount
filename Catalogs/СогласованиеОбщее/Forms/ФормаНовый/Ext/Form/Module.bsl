﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.ВариантСогласования = Перечисления.ВариантыМаршрутизацииЗадач.Смешанно;
	
	//блокируем галочку ОФК
	// 16.09.2015 для ГУКа если это заявка на авансовый отчет...обращение №3852
	Попытка
		ДоступностьКонтроляСогласованияОФК = БюджетныйНаСервере.ВернутьРеквизит(БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "Предприятие"), "НеКонтролироватьОФК");	
	Исключение
		ДоступностьКонтроляСогласованияОФК = Истина;
	КонецПопытки;
	
	Если Не ЗначениеЗаполнено(ДоступностьКонтроляСогласованияОФК) Тогда
		ДоступностьКонтроляСогласованияОФК = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоБазаСпирт() Тогда
		Элементы.КонтрольСогласованияОФК.Доступность = ДоступностьКонтроляСогласованияОФК;
	Иначе		
		
		Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаАвансовыйОтчет") И Не Объект.Заявка.Предприятие = Справочники.Предприятия.Казна Тогда
			Элементы.КонтрольСогласованияОФК.Доступность = Истина;
		Иначе
			Элементы.КонтрольСогласованияОФК.Доступность = ДоступностьКонтроляСогласованияОФК;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//Если Не ПроверкаВозможностиЗапускаБП(Объект.Заявка) Тогда
	//	Возврат
	//КонецЕсли;
	
	//БП = БПСервер.ПоискБП("СогласованиеОбщее", Объект.Заявка);

	//Если БП <> Неопределено Тогда
	//	Если БюджетныйНаСервере.ВернутьРеквизит(БП, "Стартован") Тогда
			//Если ТочкаМаршрутаДоработки(ПараметрКоманды) Тогда
			//	ВыполнитьЗадачуДоработки(БП, ПараметрКоманды);
			//	Оповестить("ОбновитьСписокЗадач");
			//	Оповестить("Пересчитать", Новый Структура("ТекущийБизнесПроцесс", БП));
			//	ОповеститьОбИзменении(ПараметрКоманды);
			//Иначе
				//ПоказатьПредупреждение(Неопределено, "Бизнес-процесс согласования уже запущен.");
				//Отказ = Истина;
			//КонецЕсли;
			//Возврат;
		//Иначе
			//ОткрытьФорму(БПСервер.ПолучитьПолноеИмяФормы(БП), Новый Структура("Ключ", БП));
			//Возврат;
	//	КонецЕсли;	
	//КонецЕсли;
		
	
	Если Объект.ТолькоИсполнение Тогда
		Элементы.Согласование.Видимость = Ложь;
		Элементы.КонтролироватьИсполнение.Видимость = Ложь;
	КонецЕсли;
	
	ОбновитьЗаголовки();
	СтандартныйМаршрутПриИзменении(Неопределено);
	
	БюджетныйНаКлиенте.ПоказатьСтарыйМаршрут(Элементы, МаршрутЗаявкиОснования);
	ПодтверждениеОзнакомленияПриИзменении(Неопределено);
	
	ВариантСогласованияПриИзменении(Неопределено);
		
	БюджетныйНаКлиенте.ФормаТолькоПросмотр(Объект, ЭтаФорма, Объект.Стартован И Объект.ОснованиеЗаблокирован, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекСтрока = Элементы.ДопСогласование.ТекущиеДанные;
	ТекСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя();
	ОбновитьЗаголовки();
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьМаршрут(ВыбранныйМаршрут)
	
	Для каждого ТекСтрока Из ВыбранныйМаршрут.МаршрутЗаявки Цикл
		НоваяСтрока = Объект.ДопСогласование.Добавить();	
	    НоваяСтрока.Автор = БюджетныйНаСервере.ПолучитьПользователя();;
		Если ТипЗнч(ТекСтрока.СубъектСогласования) = Тип("СправочникСсылка.Пользователи") Тогда
			НоваяСтрока.СубъектСогласования = ТекСтрока.СубъектСогласования;
		Иначе
			Если ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Директор ИЛИ ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Дивизионер Тогда
				Если ТекСтрока.СубъектСогласования = Справочники.Д_Должности.Директор Тогда
					Должность = "Директор";
				Иначе
					Должность = "Дивизионер";				
				КонецЕсли;
				НоваяСтрока.СубъектСогласования = Объект.Предприятие[Должность];
				Если ПустаяСтрока(НоваяСтрока.СубъектСогласования) Тогда
					Объект.ДопСогласование.Удалить(НоваяСтрока);					
				КонецЕсли;
			КонецЕсли;			
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
  
&НаКлиенте
Процедура Подбор(Команда)
	ВыбранныйМаршрут = ОткрытьФормуМодально("Справочник.Д_МаршрутыЗаявки.ФормаВыбора");
	Если НЕ ВыбранныйМаршрут = Неопределено Тогда
		ДобавитьМаршрут(ВыбранныйМаршрут);	
	КонецЕсли;
КонецПроцедуры


&НаСервере
Функция ПроверитьНаличиеБП()
    Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СогласованиеОбщее.Ссылка
	|ИЗ
	|	Справочник.СогласованиеОбщее КАК СогласованиеОбщее
	|ГДЕ
	|	СогласованиеОбщее.Заявка = &Заявка";
	
	Запрос.УстановитьПараметр("Заявка", Объект.Заявка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Количество() Тогда
		Сообщить("По данному основанию уже есть запущеный бизнес-процесс. Старт невозможен.");
	КонецЕсли;
	Возврат Выборка.Количество();
КонецФункции // ()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Объект.Наименование = "Согласование и исполнение " + Строка(Объект.Заявка);;
	
	ОФК = ПолучитьОФК(Объект.Заявка);
	
	// ГУК 23.09.2015 если исполнитель Кассир Врн или Кассир Мск, проверка ОФК обязательна {
	//Если Не ОбщегоНазначенияПовтИсп.ЭтоБазаСпирт() Тогда
	//	Для Каждого СтрокаИсп Из Объект.ДопИсполнение Цикл
	//		ТекИсполнитель = Строка(СтрокаИсп.Исполнитель);
	//		Если ТекИсполнитель = "Кассир Врн (Кассир)" ИЛИ ТекИсполнитель = "Кассир Мск (Кассир)" Тогда
	//			Объект.КонтрольСогласованияОФК = Истина;
	//			Прервать;
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;
	//}
	
	//Если Объект.КонтрольСогласованияОФК И ЗначениеЗаполнено(ОФК) И НЕ Объект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", ОФК)).Количество() Тогда
	//	НоваяСтрока = Объект.ДопСогласование.Вставить(0);
	//	НоваяСтрока.СубъектСогласования = ОФК;
	//	НоваяСтрока.РольПользователя = "Проверка ОФК";
	//КонецЕсли;
	
	
	ТрансформироватьДеревоВТЗ();
	
	//Если НЕ Объект.ДопСогласование.Количество() И НЕ Объект.ДопИсполнение.Количество() Тогда
	//	Предупреждение("Не выбран маршрут!");
	//	Элементы.Группа2.ТекущаяСтраница = Элементы.Согласование;
	//	Отказ = Истина;	
	//	Возврат;
	//КонецЕсли;
	
	//Если НЕ БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
	//	Если ПроверитьНаличиеБП() Тогда
	//		Отказ = Истина;	
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	
	ДозаполнитьРолиСогласователей();
	
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьРолиСогласователей()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	РолиИсполнителей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РолиИсполнителей КАК РолиИсполнителей
	|ГДЕ
	|	РолиИсполнителей.РольПоУмолчанию = ИСТИНА";
	
	Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Для каждого ТекСтрока Из Объект.ДопСогласование Цикл
			Если Не ЗначениеЗаполнено(ТекСтрока.РольПользователя) Тогда
				ТекСтрока.РольПользователя = Выборка.Ссылка;
			КонецЕсли;
		КонецЦикла; 	
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ТрансформироватьДеревоВТЗ()

		Если Объект.ВариантСогласования = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно") Тогда
		МасивСтрокСогл = Новый Массив;
		Для каждого ТекСтрока Из Объект.ДопСогласование Цикл
			МасивСтрокСогл.Добавить(ТекСтрока);	
		КонецЦикла;
		МасивСтрокИсп = Новый Массив;
		Для каждого ТекСтрока Из Объект.ДопИсполнение Цикл
			МасивСтрокИсп.Добавить(ТекСтрока);	
		КонецЦикла;
		МассивСтрокОзн = Новый Массив;
		Для каждого ТекСтрока Из Объект.ДопОповещение Цикл
			МассивСтрокОзн.Добавить(ТекСтрока);	
		КонецЦикла;
		
		ТекЭлементы = МаршрутДерево.ПолучитьЭлементы();
		Для каждого ТекЭлемент Из ТекЭлементы Цикл
			ДобавитьУровеньНаЗапись(ТекЭлемент.ПолучитьЭлементы(), ТекЭлемент.Пользователь);	
		КонецЦикла;
		
		Для каждого ТекСтрока Из МасивСтрокСогл Цикл
			Объект.ДопСогласование.Удалить(ТекСтрока);	
		КонецЦикла; 
		Для каждого ТекСтрока Из МасивСтрокИсп Цикл
			Объект.ДопИсполнение.Удалить(ТекСтрока);	
		КонецЦикла; 
		Для каждого ТекСтрока Из МассивСтрокОзн Цикл
			Объект.ДопОповещение.Удалить(ТекСтрока);	
		КонецЦикла;
	КонецЕсли;


КонецПроцедуры


&НаКлиенте
Процедура ДобавитьУровеньНаЗапись(ТекЭлементы,  ТекТЧ)
	Для каждого ТекЭл Из ТекЭлементы Цикл
		Если ТекЭл.ПолучитьЭлементы().Количество() Тогда
			ДобавитьУровеньНаЗапись(ТекЭл.ПолучитьЭлементы(), ТекТЧ);	
		Иначе
			Если ТекТЧ = "Согласование" Тогда
				
				НоваяСтрока = Объект.ДопСогласование.Добавить();
				НайденныеСтроки = Объект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования",  ТекЭл.Пользователь));
				Для каждого ТекНайденнаяСтрока Из НайденныеСтроки Цикл
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекНайденнаяСтрока);
				КонецЦикла; 
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
				НоваяСтрока.СубъектСогласования = ТекЭл.Пользователь;
				
				
			ИначеЕсли ТекТЧ = "Исполнение" Тогда
				НоваяСтрока = Объект.ДопИсполнение.Добавить();
				НайденныеСтроки = Объект.ДопИсполнение.НайтиСтроки(Новый Структура("Исполнитель",  ТекЭл.Пользователь));
				Для каждого ТекНайденнаяСтрока Из НайденныеСтроки Цикл
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекНайденнаяСтрока);
				КонецЦикла; 
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
				НоваяСтрока.Исполнитель = ТекЭл.Пользователь;
			Иначе
				НоваяСтрока = Объект.ДопОповещение.Добавить();
				НайденныеСтроки = Объект.ДопОповещение.НайтиСтроки(Новый Структура("Пользователь",  ТекЭл.Пользователь));
				Для каждого ТекНайденнаяСтрока Из НайденныеСтроки Цикл
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекНайденнаяСтрока);
				КонецЦикла; 
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекЭл);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПолучитьОФК(ТекЗаявка)
	
	//Если ТипЗнч(ТекЗаявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
	//	Возврат Константы.БП_КонтролерОтгрузки.Получить();
	////ИначеЕсли ТипЗнч(ТекЗаявка) = Тип("ДокументСсылка.Д_ЗаявкаНаАвансовыйОтчет") Тогда
	////	Возврат Справочники.Пользователи.НайтиПоНаименованию("Оператор Казны", Истина);
	//Иначе	
		Возврат Неопределено;	
	//КонецЕсли;


КонецФункции // ()


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	//Если ПараметрыЗаписи.Свойство("Старт") И ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
	//	УчетчикПредприятия = ПолучитьУчетчикаПредприятия(Объект.Заявка);
	//	// переадресация на учетчика офиса
	//	Если Объект.ДопСогласование.НайтиСтроки(Новый Структура("СубъектСогласования", УчетчикПредприятия)).Количество() Тогда
	//		МассивПеренаправляемыхЗадач = Новый Массив;
	//		УчетчикВСети = БПСервер.ПользовательВСети(УчетчикПредприятия);
	//		Если Не УчетчикВСети Тогда
	//			ЗадачаУч = ПолучитьЗадачуУчетчикаПредприятия(Объект.Ссылка, УчетчикПредприятия);
	//			Если ЗначениеЗаполнено(ЗадачаУч) Тогда
	//				МассивПеренаправляемыхЗадач.Добавить(ЗадачаУч);
	//			КонецЕсли;	
	//		КонецЕсли;
	//		Если МассивПеренаправляемыхЗадач.Количество() Тогда
	//			УчетчикОфиса = ПолучитьУчетчикаОфиса();
	//			СтруктураПараметров = Новый Структура("Комментарий, НовыйИсполнитель", "Пользователь "+ Строка(УчетчикПредприятия) +" будет заменен на пользователя " + Строка(УчетчикОфиса) + " в связи с его отсутствием.", УчетчикОфиса);
	//			Результат = БПСервер.ПеренаправитьСправочники(МассивПеренаправляемыхЗадач, СтруктураПараметров, Ложь);
	//		КонецЕсли;	
	//	КонецЕсли;
	//КонецЕсли;
	
	ЗаписатьОснование(Объект.Заявка);
	Оповестить("Пересчитать", Новый Структура("ТекущийБизнесПроцесс", Объект.Ссылка) , ВладелецФормы);
	Оповестить("ЗакрытьФормуДокументаВладельца", Новый Структура("ТекущийБизнесПроцесс", Объект.Ссылка) , ВладелецФормы);
	Оповестить("ОбновитьСписокЗадач");
	ОповеститьОбИзменении(Объект.Заявка);
	
	//очищаем старый маршрут
	АдресХранилищаМаршрута = Неопределено;
КонецПроцедуры        

&НаСервереБезКонтекста
Процедура ЗаписатьОснование(ТекЗаявка)
	ТекЗаявкаОбъект = ТекЗаявка.ПолучитьОбъект();
	ТекЗаявкаОбъект.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСложныйМаршрутНаКлиенте()
	
	//заполнение маршрута с группировками
	Если Объект.ВариантСогласования = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно") Тогда
		ЗаполнитьСложныйМаршрут();
		сабБПКлиентСервер.РазвернутьГруппировкиДерева(Элементы, МаршрутДерево);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСложныйМаршрут()
	
	//очищаем тек маршрут
	Тек = МаршрутДерево.ПолучитьЭлементы();
	Тек.Очистить();
	
	ТекМассМаршрутов = Новый Массив;
	
	//Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда //опрашиваем автомаршруты при открытии заполненного нового
	//	Для каждого ТекСтрока Из Объект.ДопСогласование Цикл
	//		Если ЗначениеЗаполнено(ТекСтрока.МаршрутДвижения) И ТекМассМаршрутов.Найти(ТекСтрока.МаршрутДвижения) = Неопределено Тогда
	//			ТекМассМаршрутов.Добавить(ТекСтрока.МаршрутДвижения);
	//		КонецЕсли;
	//	КонецЦикла; 
	//КонецЕсли;
	
	Если НЕ ТекМассМаршрутов.Количество() Тогда
		///для формирования дерева маршрута (неоптимально, двойной запрос маршрутов, ну да пох)
		ТекМассМаршрутов.Добавить(Объект);
	КонецЕсли;
	
	Для каждого ТекМаршрутСтрока Из ТекМассМаршрутов Цикл
		сабБПКлиентСервер.ДобавитьДеревоМаршрута(Элементы, Команды, ТекущаяСтрокаГруппы, МаршрутДерево, ТекМаршрутСтрока, УсловноеОформление, Новый Структура("ДопУсловияВидимость, ВремяНаВыполнение, ДоступенТипПользователи, Предприятие", Ложь, Истина, Истина, Объект.Предприятие) );
	КонецЦикла;
	

КонецПроцедуры


&НаКлиенте
Процедура ПодборМаршрута1(Команда)
	ВыбранныйМаршрут = ОткрытьФормуМодально("Справочник.Д_МаршрутыЗаявки.ФормаВыбора");
	Если НЕ ВыбранныйМаршрут = Неопределено Тогда
		ДобавитьМаршрут(ВыбранныйМаршрут);	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборПользователя1(Команда)
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.ДопСогласование); 
КонецПроцедуры

&НаКлиенте
Процедура ПодборПользователя2(Команда)
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.ДопИсполнение); 
КонецПроцедуры



&НаКлиенте
Процедура ПодборПользователя3(Команда)
	ОткрытьФормумодально("Справочник.Пользователи.ФормаВыбора", Новый Структура("РежимВыбора, РасширенныйПодбор, ЗакрыватьПриВыборе", Истина, Истина, Ложь),Элементы.ДопОповещение); 
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовки()
	//Элементы.Согласование.Заголовок = "Согласование";
	//Если Объект.ДопСогласование.Количество() Тогда
	//	Элементы.Согласование.Заголовок = Элементы.Согласование.Заголовок + " (" + Объект.ДопСогласование.Количество() + ")";	
	//КонецЕсли;
	//
	//Элементы.Исполнение.Заголовок = "Исполнение";
	//Если Объект.ДопИсполнение.Количество() Тогда
	//	Элементы.Исполнение.Заголовок = Элементы.Исполнение.Заголовок + " (" + Объект.ДопИсполнение.Количество() + ")";	
	//КонецЕсли;
	//
	//Элементы.Группа1.Заголовок = "Ознакомление";
	//Если Объект.ДопОповещение.Количество() Тогда
	//	Элементы.Группа1.Заголовок = Элементы.Группа1.Заголовок + " (" + Объект.ДопОповещение.Количество() + ")";	
	//КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ДопСогласованиеПослеУдаления(Элемент)
		ОбновитьЗаголовки();
КонецПроцедуры


&НаКлиенте
Процедура ДопИсполнениеПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		ОбновитьЗаголовки();

КонецПроцедуры


&НаКлиенте
Процедура ДопИсполнениеПослеУдаления(Элемент)
		ОбновитьЗаголовки();

КонецПроцедуры


&НаКлиенте
Процедура ДопОповещениеПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
		ОбновитьЗаголовки();

КонецПроцедуры


&НаКлиенте
Процедура ДопОповещениеПослеУдаления(Элемент)
		ОбновитьЗаголовки();

КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПередУдалением(Элемент, Отказ)
	
	Если ЗначениеЗаполнено(БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "Предприятие")) И ЗначениеЗаполнено(Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования) Тогда
		Если ПроверкаНаУчетчика() = Элемент.ТекущиеДанные.СубъектСогласования Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Невозможно удалить учетчика предприятия из маршрута согласования!";
			Сообщение.Сообщить();
			Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;
	
	Если ПолучитьОФК(Объект.Заявка) = Элемент.ТекущиеДанные.СубъектСогласования И Объект.КонтрольСогласованияОФК И Не РольАдминистратора() Тогда
		Сообщение = Новый СообщениеПользователю;
		//Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
		//	Сообщение.Текст = "Невозможно удалить контролера отгрузки из маршрута согласования!";
		//Иначе	
			Сообщение.Текст = "Невозможно удалить сотрудника ОФК из маршрута согласования!";
		//КонецЕсли;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "ВидСЗ") = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.ЗаявкаНаСогласованиеДоговора") Тогда
			ЗначениеСвойства = ЕстьВозможностьИзменятьМаршрутДоговоров();
			Если Не ЗначениеСвойства Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Невозможно удалять сотрудников из стандартного маршрута!";
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ДопСогласование.ТекущиеДанные.Обязателен Тогда
		Сообщить("Cубъект согласования " + Строка(Элемент.ТекущиеДанные.СубъектСогласования) + " обязателен в маршруте! Удаление невозможно!");
		Отказ = Истина;
	КонецЕсли;
	

КонецПроцедуры

&НаСервере
Функция ПроверкаНаУчетчика()
	
	Возврат БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(Объект.Заявка.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУчетчикаПредприятия(Заявка)
	Возврат БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(Заявка.Предприятие, Перечисления.ОсновныеДолжностиПредприятия.Учетчик);	
КонецФункции

&НаСервереБезКонтекста
Функция РольАдминистратора()
	
	Возврат РольДоступна("Администратор");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьУчетчикаОфиса()
	Возврат Справочники.Пользователи.ПустаяСсылка();	//нужно исправить!!! на основную должость предприятия
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗадачуУчетчикаПредприятия(БП, Учетчик)
	
	ТекЗадача = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("БП", БП);
	Запрос.УстановитьПараметр("Исполнитель", Учетчик);
	Запрос.УстановитьПараметр("ТочкаМаршрута", Перечисления.СогласованиеОбщееТочкиМаршрута.Действие2);
	Запрос.Текст = "ВЫБРАТЬ
	               |	Задача.Ссылка
	               |ИЗ
	               |	Справочник.Задача КАК Задача
	               |ГДЕ
	               |	Задача.БизнесПроцесс = &БП
	               |	И Задача.Исполнитель = &Исполнитель
	               |	И Задача.ТочкаМаршрута = &ТочкаМаршрута
	               |	И Задача.ПометкаУдаления = ЛОЖЬ";
				   
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекЗадача = Выборка.Ссылка;
	КонецЦикла;
	
	Возврат ТекЗадача;
	
КонецФункции

&НаКлиенте
Процедура СтандартныйМаршрутПриИзменении(Элемент)
	Элементы.Группа2.ТолькоПросмотр = Объект.СтандартныйМаршрут;
	Элементы.ДопСогласованиеГруппа1.Доступность = НЕ Объект.СтандартныйМаршрут;
	//Элементы.Исполнение.ТолькоПросмотр = НЕ Объект.СтандартныйМаршрут;
	Элементы.ДопСогласованиеГруппа2.Доступность = НЕ Объект.СтандартныйМаршрут;
	Элементы.ДопСогласованиеГруппа3.Доступность = НЕ Объект.СтандартныйМаршрут;
	Элементы.ВариантСогласования.Доступность = НЕ Объект.СтандартныйМаршрут;
	Если НЕ Объект.СтандартныйМаршрут Тогда
		Элементы.СтандартныйМаршрут.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	//Модифицированность = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМаршрутИзСтарого(Команда)
	Если ЗначениеЗаполнено(МаршрутЗаявкиОснования) Тогда
		Если Вопрос("Внимание! Данные текущего запроса будут заменены. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			ЗаполнитьМаршрутИзСтарогоСервер();
			СтандартныйМаршрутПриИзменении(Неопределено);
		КонецЕсли;
	Иначе
		Предупреждение("Не найден маршрут-основание!");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМаршрутИзСтарогоСервер()
	
	Если Не ЗначениеЗаполнено(МаршрутЗаявкиОснования) ИЛИ НЕ ТипЗнч(МаршрутЗаявкиОснования) = Тип("СправочникСсылка.СогласованиеОбщее") Тогда
		Возврат;	
	КонецЕсли;
	
	Для каждого ТЧ Из МаршрутЗаявкиОснования.Метаданные().ТабличныеЧасти Цикл
		
		Если ТЧ.Имя = "ДопСогласование" Тогда
			КолвоСтрок = Объект[ТЧ.Имя].Количество();
			
			Для ОбрИнд = 1 По КолвоСтрок Цикл
				
				Если Объект[ТЧ.Имя][КолвоСтрок - ОбрИнд].Обязателен Тогда
					Продолжить;
				КонецЕсли;
				
				Объект[ТЧ.Имя].Удалить(КолвоСтрок - ОбрИнд);
			КонецЦикла;
			
		Иначе	
			Объект[ТЧ.Имя].Очистить();
		КонецЕсли;

		Для каждого ТекСтрока Из МаршрутЗаявкиОснования[ТЧ.Имя] Цикл
			
			Если ТЧ.Имя = "ДопСогласование" И Объект[ТЧ.Имя].НайтиСтроки(Новый Структура("СубъектСогласования", ТекСтрока.СубъектСогласования)).Количество() Тогда
				Продолжить;
			КонецЕсли;

			НоваяСтрока = Объект[ТЧ.Имя].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			
			//боб1
			Если ТЧ.Имя = "ДопСогласование" Тогда
				НоваяСтрока.Согласовано = Ложь;
				НоваяСтрока.Пройден = Ложь;
				НоваяСтрока.Пользователь = "";
				НоваяСтрока.Комментарии = "";
				НоваяСтрока.Автор = ПараметрыСеанса.ТекущийПользователь;
				НоваяСтрока.ДатаВыполнения = Дата('00010101000000');
				НоваяСтрока.НомерИтерации = 0;
			КонецЕсли;
			
			//боб2
			Если ТЧ.Имя = "ДопОповещение" Тогда
				НоваяСтрока.Оповещен = Ложь;
				НоваяСтрока.НомерИтерации = 0;
			КонецЕсли;

			//боб3
			Если ТЧ.Имя = "ДопИсполнение" Тогда
				НоваяСтрока.Исполнено = Ложь;
				НоваяСтрока.Пройдено = Ложь;
				НоваяСтрока.Пользователь = "";
				НоваяСтрока.Комментарии = "";
				НоваяСтрока.Автор = ПараметрыСеанса.ТекущийПользователь;
				НоваяСтрока.ПринятоКИсполнению = Ложь;
				НоваяСтрока.НомерИтерации = 0;
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЦикла;
	
	Объект.СтандартныйМаршрут = Ложь;
	//Объект.КонтрольСогласованияОФК = МаршрутЗаявкиОснования.КонтрольСогласованияОФК;
	

КонецПроцедуры


&НаКлиенте
Процедура ДопСогласованиеПередНачаломИзменения(Элемент, Отказ)
	
	Если ПолучитьОФК(Объект.Заявка) = Элемент.ТекущиеДанные.СубъектСогласования И Объект.КонтрольСогласованияОФК И Не РольАдминистратора() Тогда
		Сообщение = Новый СообщениеПользователю;
		//Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаОтгрузку") Тогда
		//	Сообщение.Текст = "Невозможно удалить контролера отгрузки из маршрута согласования!";
		//Иначе	
			Сообщение.Текст = "Невозможно удалить сотрудника ОФК из маршрута согласования!";
		//КонецЕсли;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "ВидСЗ") = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.ЗаявкаНаСогласованиеДоговора") Тогда
			ЗначениеСвойства = ЕстьВозможностьИзменятьМаршрутДоговоров();
			Если Не ЗначениеСвойства Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Невозможно удалять сотрудников из стандартного маршрута!";
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ДопСогласование.ТекущиеДанные.Обязателен Тогда
		Сообщить("Cубъект согласования " + Строка(Элемент.ТекущиеДанные.СубъектСогласования) + " обязателен в маршруте! Редактирование невозможно!");
		Отказ = Истина;
	КонецЕсли;


КонецПроцедуры


&НаКлиенте
Процедура ПодтверждениеОзнакомленияПриИзменении(Элемент)
	Элементы.ВариантОзнакомления.Доступность = Объект.ПодтверждениеОзнакомления;
	Если НЕ Элемент = Неопределено Тогда
		Если НЕ Объект.ПодтверждениеОзнакомления Тогда
			Объект.ВариантОзнакомления = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Параллельно");		
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЕстьВозможностьИзменятьМаршрутДоговоров()
	
	ЗначениеСвойства = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Доступно изменение маршрута по договорам");
	Если ЗначениеСвойства = Неопределено Тогда
		Возврат Ложь;
	Иначе 
		Возврат ЗначениеСвойства;
	КонецЕсли;	
	
КонецФункции

&НаКлиенте
Процедура ДопСогласованиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") Тогда
		Если БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "ВидСЗ") = ПредопределенноеЗначение("Справочник.Д_ВидыВнутреннихДокументов.ЗаявкаНаСогласованиеДоговора") Тогда
			ЗначениеСвойства = ЕстьВозможностьИзменятьМаршрутДоговоров();
			Если Не ЗначениеСвойства Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Невозможно добавлять сотрудников в стандартный маршрут!";
				Сообщение.Сообщить();
				Отказ = Истина;
			КонецЕсли;	
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

///////////////////////////////генерирование дерева маршрутов///////////////////////
#Область ГенерированиеДереваМаршрутов
	
&НаКлиенте
Процедура Реквизит1ПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Пользователь = "Согласование" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Исполнение" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Ознакомление" Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущиеДанные.Пользователь = "Группа И" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Группа ИЛИ" Тогда
		Массив = Новый Массив;
		Массив.Добавить(Тип("Строка"));
		ОписаниеТиповС = Новый ОписаниеТипов(Массив);
		Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;
		
		Элементы.Колонка1.РежимВыбораИзСписка = Истина;
		ТекСписок = Новый СписокЗначений;
		Элементы.Колонка1.СписокВыбора.Добавить("Группа И");
		Элементы.Колонка1.СписокВыбора.Добавить("Группа ИЛИ");
	КонецЕсли;
	//Элементы.Колонка1.ВыбиратьТип = Ложь;
	//Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Пользователь) Тогда
	//	Элемент.ТекущиеДанные.Пользователь = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	//КонецЕсли;
	
	Если Элемент.ТекущиеДанные.Обязателен Тогда
		Сообщить("Cубъект согласования " + Строка(Элемент.ТекущиеДанные.Пользователь) + " обязателен в маршруте! Редактирование невозможно!");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриАктивизацииСтроки(Элемент)
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		Если ТипЗнч(Элемент.ТекущиеДанные.Пользователь) = Тип("Строка") Тогда
			ТекущаяСтрокаГруппы = Элемент.ТекущиеДанные.ИдГруппы;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПередУдалением(Элемент, Отказ)
	Если Элемент.ТекущиеДанные.Пользователь = "Согласование" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Исполнение" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Ознакомление" Тогда
		Отказ = Истина;	
	КонецЕсли;
	Если Элемент.ТекущиеДанные.Обязателен Тогда
		Сообщить("Cубъект согласования " + Строка(Элемент.ТекущиеДанные.Пользователь) + " обязателен в маршруте! Удаление невозможно!");
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьГруппу(Команда)
	
	Элементы.Колонка1.СписокВыбора.Очистить();
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("Строка"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив);
	Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;

	
	Элементы.ТаблицаФормы123.ДобавитьСтроку();
	//Элементы.ТаблицаФормы123.ТекущиеДанные.Пользователь = "";
	Элементы.Колонка1.РежимВыбораИзСписка = Истина;
	ТекСписок = Новый СписокЗначений;
	Элементы.Колонка1.СписокВыбора.Добавить("Группа И");
	Элементы.Колонка1.СписокВыбора.Добавить("Группа ИЛИ");
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Элементы.Колонка1.СписокВыбора.Очистить();
	Элементы.Колонка1.РежимВыбораИзСписка = Ложь;
	Если Элемент.ТекущиеДанные.Пользователь = "Группа И" ИЛИ Элемент.ТекущиеДанные.Пользователь = "Группа ИЛИ" Тогда
		Элемент.ТекущиеДанные.ЭтоГруппа = Истина;
		ТекущаяСтрокаГруппы = Новый УникальныйИдентификатор;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.ИДГруппы) Тогда
		Элемент.ТекущиеДанные.ИДГруппы = ТекущаяСтрокаГруппы;
	КонецЕсли;
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.Пользователи"));
	//Массив.Добавить(Тип("ПеречислениеСсылка.ОсновныеДолжностиПредприятия"));
	//Массив.Добавить(Тип("СправочникСсылка.Д_Должности"));
	ОписаниеТиповС = Новый ОписаниеТипов(Массив);
	
	Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;
	
	
	Уровень = 0;
	ТекЭлемент = Элемент.ТекущиеДанные.ПолучитьРодителя();
	Пока НЕ ТекЭлемент = Неопределено Цикл
		Уровень = Уровень + 1;
		ТекЭлемент = ТекЭлемент.ПолучитьРодителя();
	КонецЦикла;
	Элемент.ТекущиеДанные.Уровень = Уровень;
	
	Если Уровень = 1 Тогда
		Элемент.ТекущиеДанные.ТипГруппы = "Группа И";
	Иначе
		ТекРодитель = Элемент.ТекущиеДанные.ПолучитьРодителя();
		Если НЕ ТекРодитель = Неопределено Тогда
			Элемент.ТекущиеДанные.ТипГруппы = ТекРодитель.Пользователь;
		КонецЕсли;
	КонецЕсли;
	
	//работа с ТЧ
	//УстановитьИдСтроки(Элемент);
	

КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ Копирование Тогда
		Если НЕ ТипЗнч(Элемент.ТекущиеДанные.Пользователь) =  Тип("Строка") Тогда
			Отказ = Истина;
			Элемент.ТекущаяСтрока = МаршрутДерево.НайтиПоИдентификатору(Элемент.ТекущаяСтрока).ПолучитьРодителя().ПолучитьИдентификатор();
			Элемент.ДобавитьСтроку();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НЕ Элементы.Колонка1.ОграничениеТипа.СодержитТип(Тип("Строка")) Тогда
		
		Если Элементы.ТаблицаФормы123.ТекущиеДанные.Пользователь = Неопределено Тогда
			Элементы.ТаблицаФормы123.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура Реквизит1ДопСогласованиеСубъектСогласованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ Элементы.Колонка1.ОграничениеТипа.СодержитТип(Тип("Строка")) Тогда
		СтандартнаяОбработка = Ложь;
		ТекущийПользователь = ?(Элементы.ТаблицаФормы123.ТекущиеДанные = Неопределено,
		Неопределено, Элементы.ТаблицаФормы123.ТекущиеДанные.Пользователь);
		ВыбратьПользователей(ТекущийПользователь, Элемент);
	КонецЕсли	
КонецПроцедуры


&НаКлиенте
Процедура Реквизит1ДопУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФормуМодально("Справочник.МаршрутыДвиженияЗаявок.Форма.ФормаДопУсловий", Новый Структура("ИД", Элемент.Родитель.ТекущиеДанные.ИДСтроки), ЭтаФорма);

КонецПроцедуры

&НаКлиенте                                                                     
Процедура Реквизит1Перетаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	а = 1;
	ЗначениеКуда = МаршрутДерево.НайтиПоИдентификатору(Строка);
	ЗначениеЧто = МаршрутДерево.НайтиПоИдентификатору(Элемент.ТекущаяСтрока);	
	Если НЕ ЗначениеКуда.ИдГруппы = Элемент.ТекущиеДанные.ИдГруппы Тогда
		Вставка = Ложь;
		Если НЕ ТипЗнч(ЗначениеКуда.Пользователь) = Тип("Строка") Тогда
			Вставка = Истина;
			Пока НЕ ТипЗнч(ЗначениеКуда.Пользователь) = Тип("Строка") Цикл
				ЗначениеКуда = ЗначениеКуда.ПолучитьРодителя();			
			КонецЦикла;		
		КонецЕсли;
		
		Элемент.ТекущиеДанные.ИдГруппы = ЗначениеКуда.ИдГруппы;
		Уровень = 1; //т.к. получаем родителя у группы
		ТекЭлемент = ЗначениеКуда.ПолучитьРодителя();
		Пока НЕ ТекЭлемент = Неопределено Цикл
			Уровень = Уровень + 1;
			ТекЭлемент = ТекЭлемент.ПолучитьРодителя();
		КонецЦикла;
		Элемент.ТекущиеДанные.Уровень = Уровень;
		
		Если Уровень = 1 Тогда
			Элемент.ТекущиеДанные.ТипГруппы = "Группа И";
		Иначе
			Элемент.ТекущиеДанные.ТипГруппы = ЗначениеКуда.Пользователь;
		КонецЕсли;
		
		ЭлементыКуда = ЗначениеКуда.ПолучитьЭлементы();
		//Если Вставка Тогда
		//	НовыйЭлемент = ЭлементыКуда.Вставить(МаршрутДерево.НайтиПоИдентификатору(Строка).ПолучитьИдентификатор());
		//Иначе
		НовыйЭлемент = ЭлементыКуда.Добавить();
		//КонецЕсли;
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент.ТекущиеДанные);
		
		РодительЧто = ЗначениеЧто.ПолучитьРодителя();
		РодительЧто.ПолучитьЭлементы().Удалить(ЗначениеЧто);
		
	КонецЕсли;

	//Элемент.ТекущаяСтрока = Строка;                                              
	//Если НЕ ТипЗнч(Элемент.ТекущиеДанные.Пользователь) =  Тип("Строка") Тогда
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли;
КонецПроцедуры

#КонецОбласти 

&НаКлиенте
Процедура ВариантСогласованияПриИзменении(Элемент)
	
	Если ТипЗнч(Объект.Заявка) = Тип("ДокументСсылка.Д_ЗаявкаНаСогласованиеДоговора") И ПодвидДоговораСтройка(Объект.Заявка) Тогда // по обр №00000003631 от Толстых
		Объект.ВариантСогласования = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно");
		Элементы.ВариантСогласования.Доступность = Ложь;
	КонецЕсли;
	
	СложныйМаршрут = Объект.ВариантСогласования = ПредопределенноеЗначение("Перечисление.ВариантыМаршрутизацииЗадач.Смешанно");
	Элементы.Согласование.Видимость = НЕ СложныйМаршрут;
	Элементы.Исполнение.Видимость = НЕ СложныйМаршрут;
	Элементы.Группа1.Видимость = НЕ СложныйМаршрут;
	Элементы.Группа8.Видимость = НЕ СложныйМаршрут;
	Элементы.НовыйВидМаршрута.Видимость = СложныйМаршрут;
	
	Если СложныйМаршрут Тогда
		ЗаполнитьСложныйМаршрутНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПодвидДоговораСтройка(Заявка)
	Возврат Заявка.ВидСЗ = Справочники.Д_ВидыВнутреннихДокументов.ПолучитьЭлементПредопределенный("ЗаявкаНаСогласованиеДоговора");
КонецФункции // ()


#Область УниверсальныйВыборПользователя

&НаКлиенте
Процедура ВыбратьПользователей(ТекущийПользователь, Элемент)
		
	//Если ЗначениеЗаполнено(ТекущийПользователь)
	//   И (    ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.Пользователи")
	//      ИЛИ ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ГруппыПользователей") ) Тогда
	//	
	//	ВыборИПодборВнешнихПользователей = Ложь;
		
	//ИначеЕсли ИспользоватьВнешнихПользователей
	//        И ЗначениеЗаполнено(ТекущийПользователь)
	//        И (    ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ВнешниеПользователи")
	//           ИЛИ ТипЗнч(ТекущийПользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") ) Тогда
	//
	//	ВыборИПодборВнешнихПользователей = Истина;
	//Иначе
	//	ПоказатьВыборТипаПользователиИлиВнешниеПользователи(
	//		Новый ОписаниеОповещения("ВыбратьПользователейЗавершение", ЭтотОбъект));
	//	Возврат;
	//КонецЕсли;
	
	ВыбратьПользователейЗавершение(Ложь, Элемент, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьВыборТипаПользователиИлиВнешниеПользователи(ОбработкаПродолжения)
	
	ВыборИПодборВнешнихПользователей = Ложь;
	
	//Если ИспользоватьВнешнихПользователей Тогда
	//	
	//	СписокТиповПользователей.ПоказатьВыборЭлемента(
	//		Новый ОписаниеОповещения(
	//			"ПоказатьВыборТипаПользователиИлиВнешниеПользователиЗавершение",
	//			ЭтотОбъект,
	//			ОбработкаПродолжения),
	//		НСтр("ru = 'Выбор типа данных'"),
	//		СписокТиповПользователей[0]);
	//Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ВыборИПодборВнешнихПользователей);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователейЗавершение(ВыборИПодборВнешнихПользователей, Элемент, ТекущийПользователь = Неопределено) Экспорт
	
	Если ВыборИПодборВнешнихПользователей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ТекущаяСтрока", ?(
		Элементы.ДопСогласование.ТекущиеДанные = Неопределено,
		?(ТекущийПользователь = Неопределено, Неопределено, ТекущийПользователь),
		Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования));
	
	Если ВыборИПодборВнешнихПользователей Тогда
		ПараметрыФормы.Вставить("ВыборГруппВнешнихПользователей", Истина);
	Иначе
		ПараметрыФормы.Вставить("ВыборГруппПользователей", Истина);
	КонецЕсли;
	
	Если ВыборИПодборВнешнихПользователей Тогда
		
		ОткрытьФорму(
			"Справочник.ВнешниеПользователи.ФормаВыбора",
			ПараметрыФормы,
			Элемент);
	Иначе
		ОткрытьФорму(
			"Справочник.Пользователи.ФормаВыбора",
			ПараметрыФормы,
			Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьДанныеВыбораПользователя(Текст)
	
	Возврат Пользователи.СформироватьДанныеВыбораПользователя(Текст);
	
КонецФункции

&НаКлиенте
Процедура ДопСогласованиеСубъектСогласованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования = Неопределено Тогда
		Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
		//Элементы.ГруппыПрав.ТекущиеДанные.НомерКартинки = -1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДопИсполнениеСубъектСогласованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопИсполнениеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Элементы.ДопИсполнение.ТекущиеДанные.Исполнитель = Неопределено Тогда
		Элементы.ДопИсполнение.ТекущиеДанные.Исполнитель  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДопОповещениеСубъектСогласованияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = СформироватьДанныеВыбораПользователя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДопОповещениеПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Элементы.ДопОповещение.ТекущиеДанные.Пользователь = Неопределено Тогда
		Элементы.ДопОповещение.ТекущиеДанные.Пользователь  = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДопСогласованиеСубъектСогласованияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущийПользователь = ?(Элементы.ДопСогласование.ТекущиеДанные = Неопределено,
	Неопределено, Элементы.ДопСогласование.ТекущиеДанные.СубъектСогласования);
	ВыбратьПользователей(ТекущийПользователь, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДопИсполнениеИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущийПользователь = ?(Элементы.ДопИсполнение.ТекущиеДанные = Неопределено,
	Неопределено, Элементы.ДопИсполнение.ТекущиеДанные.Исполнитель);
	ВыбратьПользователей(ТекущийПользователь, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДопОповещениеПользовательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущийПользователь = ?(Элементы.ДопОповещение.ТекущиеДанные = Неопределено,
	Неопределено, Элементы.ДопОповещение.ТекущиеДанные.Пользователь);
	ВыбратьПользователей(ТекущийПользователь, Элемент);
КонецПроцедуры


#КонецОбласти 

&НаКлиенте
Процедура СтартоватьИЗакрыть(Команда)
	Объект.Стартован = Истина;
	Записать();
	Закрыть();
КонецПроцедуры
