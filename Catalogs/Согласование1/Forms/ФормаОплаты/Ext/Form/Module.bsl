﻿&НаСервере
Процедура ВыполненоСервер(ПроверкаУспешно, ВставлятьКомм)
	
	НачатьТранзакцию();
	
	//добавляем комментарии в историю переписки
	БП = Объект.БизнесПроцесс.ПолучитьОбъект();
		
	Объект.Комментарии = Строка(ТекущаяДата()) + ": " + ПараметрыСеанса.ТекущийПользователь + 
		?(ВставлятьКомм, ?(ПроверкаУспешно, "", " не") + " оплатил(а)", " отменил(а)") + " заявку:
		|" + Комментарий;
		БП.Комментарии = БП.Комментарии + "
		|" + Объект.Комментарии;
	
	БП.СогласованоДействие4 = ПроверкаУспешно;
	
	Если НЕ ВставлятьКомм Тогда // если заявка согласована или нет
		СтруктураПоиска = Новый Структура("Пользователь", ПараметрыСеанса.ТекущийПользователь);
		МассивСтрок = БП.ДопСогласование.НайтиСтроки(СтруктураПоиска);
		Если МассивСтрок.Количество() Тогда //если отменяет один из рецензентов
			Для каждого ТекСтрока Из МассивСтрок Цикл
				ТекСтрока.Пройден = 0;
				ТекСтрока.Согласовано = 0;
				ТекСтрока.ДатаВыполнения = ТекущаяДата();
				ТекСтрока.Комментарии = "Отменил(а) заявку. " + Строка(Комментарий);
				Комментарий = "Отменил(а) заявку. " +  Комментарий;
				ТекСтрока.Пользователь = ПараметрыСеанса.ТекущийПользователь;
			КонецЦикла;
		Иначе //если отменяет не рецензент
			Комментарий = "Отменил(а) заявку. " +  Комментарий;
		КонецЕсли;
	КонецЕсли;
	
	//Заявка = БП.Заявка.ПолучитьОбъект();
	//Заявка.СостояниеДокумента = ;
	////Заявка.ДатаОплаты = ТекущаяДата();  пока не нужно, т.к. есть "старые" заявки
	//Заявка.Записать();
	
	Если БП.ХранилищеТабДока.Получить() = Неопределено Тогда
	
		// 10.10.2012 создание таб дока и помещение его в хранилище
		ТабДок = Новый ТабличныйДокумент;
	
		МассивДоков = Новый Массив;
		МассивДоков.Добавить(БП.Заявка);
	
		Документы.Д_ЗаявкаНаОплату.Печать(ТабДок, МассивДоков, "ПечатьБезНалБух");
		
		АдресВХ = ПоместитьВоВременноеХранилище(ТабДок, Новый УникальныйИдентификатор());
		РеквизитСХранилищем = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(АдресВХ));
		БП.ХранилищеТабДока = РеквизитСХранилищем;
		
	КонецЕсли;
		
	БП.Записать();
	
	БПСервер.ВыполнитьЗадачу(Объект.Ссылка, 0, ?(ПроверкаУспешно, "Да.", "Нет."), Комментарий);
	//БПСервер.ИзменитьСостояниеДокумента(Объект.Заявка, 1 - ПроверкаУспешно, , ?(ПроверкаУспешно, Перечисления.Д_СостоянияДокументов.Исполнен, Перечисления.Д_СостоянияДокументов.НаДоработке));
	
	//БПСервер.ИзменитьСостояниеДокумента(Объект.Заявка, НаДоработке);
	
	//поиск отмененных позиций
	БПСервер.ОповеститьПользователяОбОтмененныхПозициях(Объект.Заявка);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверятьПодчиненные(ТекПредприятие, ТекРольПользователя)
	
	Если БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(ТекПредприятие) И (ТекРольПользователя = "РешениеОбОплате" Или ТекРольПользователя = "ДопПроверка" Или 
			ТекРольПользователя = Справочники.РолиИсполнителей.РешениеОбОплате Или ТекРольПользователя = Справочники.РолиИсполнителей.ДопПроверка) Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Проверять = сабОбщегоНазначения.ПолучитьЗначениеСвойства(Константы.ТекущаяИБ.Получить(), "Запретить исполнение заявок на оплату без создания подчиненных документов");
	
	Если Проверять = Истина И БПСервер.МеханизмСНесколькимиИсполнителями(ТекПредприятие) Тогда
		Если ТипЗнч(ТекРольПользователя) = Тип("СправочникСсылка.РолиИсполнителей") И ЗначениеЗаполнено(ТекРольПользователя.НеобходомоСоздатьДокумент) Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Иначе	
		Возврат ?(Проверять = Неопределено, Ложь, Проверять);
	КонецЕсли;
	
КонецФункции // ()


&НаКлиенте
Процедура ЗаявкаСогласована(Команда)
	
	Если ПроверятьПодчиненные(Объект.Предприятие, Объект.РольПользователя) Тогда
			
		Если БюджетныйНаСервере.ВернутьРеквизит(Объект.Заявка, "ТипИсточника") = ПредопределенноеЗначение("Перечисление.Д_ИсточникиСредств.Нал") Тогда
			//РезультатПроверки = ПроверитьНаличиеПлатежныхДокументовНал(Объект.Заявка);
			//
			//Если РезультатПроверки = 1 Тогда
			//	Предупреждение("Не найдено связанных с завкой платежных документов. Создайте их");
			//	Возврат;
			//ИначеЕсли РезультатПроверки = 2 Тогда
			//	Ответ = Вопрос("Сумма созданных документов меньше заявленной. Вы уверены, что хотите исполнить заявку на оплату?", РежимДиалогаВопрос.ДаНет);
			//	
			//	Если Ответ = КодВозвратаДиалога.Нет Тогда
			//		Возврат;
			//	КонецЕсли;
			//	
			//КонецЕсли;
			
		Иначе
			МассивСтрокБезПП = ПроверитьНаличиеПлатежныхДокументовБезНал(Объект.Заявка);
			
			Если МассивСтрокБезПП.Количество() Тогда
				ТекстПредупреждения = "Не созданы платежные документы по не отмененным строкам заявки. Строки: ";
				
				Для Каждого НомерСтр Из МассивСтрокБезПП Цикл
					ТекстПредупреждения = ТекстПредупреждения + Символы.ПС + НомерСтр;
				КонецЦикла;
				
				Предупреждение(ТекстПредупреждения);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("оплатить данную заявку") Тогда
		Возврат;
	КонецЕсли; 
	
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
		Возврат;	
	КонецЕсли;
	
	Если БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Объект.Предприятие) Тогда
		
		Для Каждого СтрокаЧастичнойОплаты Из ТаблицаЧастичнойОплаты Цикл
			//Если Не ЗначениеЗаполнено(СтрокаЧастичнойОплаты.СуммаЧастичнойОплаты) Тогда
			//	Сообщение = Новый СообщениеПользователю;
			//	Сообщение.Текст = "Не заполнена сумма частичной оплаты!";
			//	Сообщение.Поле = "ТаблицаЧастичнойОплаты[" + ТаблицаЧастичнойОплаты.Индекс(СтрокаЧастичнойОплаты) + "].СуммаЧастичнойОплаты";
			//	Сообщение.Сообщить();
			//	Возврат;
			//КонецЕсли;
			
			Если СтрокаЧастичнойОплаты.СуммаЧастичнойОплаты > СтрокаЧастичнойОплаты.ОсталосьОплатить Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Сумма частичной оплаты не может быть больше чем сумма, которую осталось оплатить!";
				Сообщение.Поле = "ТаблицаЧастичнойОплаты[" + ТаблицаЧастичнойОплаты.Индекс(СтрокаЧастичнойОплаты) + "].СуммаЧастичнойОплаты";
				Сообщение.Сообщить();
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	//Если Записать() Тогда
	
	Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
		//ВыполненоСервер(1, 1);
		БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ОбновитьСписокЗадач");
		Закрыть();
	КонецЕсли;
	
	//КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БП = Объект.БизнесПроцесс.ПолучитьОбъект();
	ТЗ = БП.ДопСогласование.Выгрузить();
	ДопСогласование.Загрузить(ТЗ);
	
	//МассивПользователей = БПСервер.ПолучитьМассивПользователей();
	Если НЕ БПСервер.ТекПользовательИсполнительЗадачи(Объект.Ссылка) Тогда
		Элементы.ЗаявкаСогласована.Видимость = 0;
		Элементы.НаДоработку.Видимость = 0;
		//Элементы.Группа9.Видимость = Ложь;
		
		ЕстьВМаршруте = Ложь;  //Если пользователь в маршруте, то покажем декорации
		ДоступныеПользователи = БПСервер.ПолучитьМассивПользователей();
		БП = Объект.Ссылка.БизнесПроцесс;
		Для каждого ТекПользователь Из ДоступныеПользователи Цикл
			Если НЕ БП.ДопСогласование.Найти(ТекПользователь, "СубъектСогласования") = Неопределено Тогда
				ЕстьВМаршруте = Истина;			
			КонецЕсли;
		КонецЦикла;
		Элементы.ДекорацияИнформация.Видимость = ЕстьВМаршруте;
		Элементы.ДекорацияОтменаЗаявкиПояснение.Видимость = ЕстьВМаршруте;
	Иначе 
		Элементы.ОтменаОплаты.Видимость = 0;
		Элементы.ДекорацияИнформация.Видимость = 0;
		Элементы.ДекорацияОтменаЗаявкиПояснение.Видимость = 0;
	КонецЕсли;
	
	Объект.Комментарии = Объект.БизнесПроцесс.ПолучитьОбъект().Комментарии;
	
	//Элементы.ЗадачаЗадачаУстановитьСрокВыполнения.Видимость = Не Объект.ВРаботе;
	Если Объект.ВРаботе Тогда
		Элементы.ЗадачаЗадачаВзятьЗадачуВРаботу.Заголовок = "Отложить оплату";	
	КонецЕсли;
	сабОбщегоНазначения.ОбновитьКоличествоПрикрепленныхФайловСервер(ЭтаФорма);
	
	Если БПСервер.ИспользуетсяМеханизмЧастичнойОплаты(Объект.Предприятие) Тогда
		Если Объект.РольПользователя = "РешениеОбОплате" Или Объект.РольПользователя = Справочники.РолиИсполнителей.РешениеОбОплате Тогда
			Для Каждого СтрокаЗаявки Из Объект.Заявка.ЗаявкаБезнал Цикл
				СтрокаЧастичнойОплаты = ТаблицаЧастичнойОплаты.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЧастичнойОплаты, СтрокаЗаявки);
				СтрокаЧастичнойОплаты.ОсталосьОплатить = СтрокаЧастичнойОплаты.СуммаДДС - СтрокаЧастичнойОплаты.УжеОплачено;
				Если Не ЗначениеЗаполнено(СтрокаЧастичнойОплаты.СуммаЧастичнойОплаты) Тогда
					СтрокаЧастичнойОплаты.СуммаЧастичнойОплаты = СтрокаЧастичнойОплаты.ОсталосьОплатить;
				КонецЕсли;	
			КонецЦикла;	
			Элементы.ГруппаЧастичнаяОплата.Видимость = Истина;
			Элементы.ЗаявкаСогласована.Заголовок = "Отправить на оплату";
			Элементы.СоздатьДвиженияДС.Видимость = Ложь;
			Элементы.ЗакрытьЗаявку.Видимость = Истина;
		ИначеЕсли Объект.РольПользователя = "ДопПроверка" Или Объект.РольПользователя = Справочники.РолиИсполнителей.ДопПроверка Тогда
			Элементы.ЗаявкаСогласована.Заголовок = "Отправить на оплату";
			Элементы.СоздатьДвиженияДС.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если БПСервер.МеханизмСНесколькимиИсполнителями(Объект.Предприятие) Тогда
		Если Не Объект.РольПользователя = Справочники.РолиИсполнителей.ИсполнительОплаты Тогда
			Элементы.ЗаявкаСогласована.Заголовок = "Отправить на оплату";
			Элементы.СоздатьДвиженияДС.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;	
		
	//Блокировка = Новый БлокировкаДанных;
	//ЭлементБлокировки = Блокировка.Добавить("Справочник.Задача");
	//ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	//ЭлементБлокировки.УстановитьЗначение("Ссылка", Объект.Ссылка);
	//Блокировка.Заблокировать();
	
КонецПроцедуры


&НаКлиенте
Процедура НаДоработку(Команда)
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("отправить на доработку данную заявку") Тогда
		Возврат;
	КонецЕсли; 
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
		
	//Если ПроверитьКомментарий() Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если ПустаяСтрока(Комментарий) Тогда
		сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(Объект,  "Не указана причина возврата на доработку",,, "Комментарий", Истина);
		Возврат;
	КонецЕсли;
		
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//ВыполненоСервер(0, 1);
			БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;
	
	// оповестить о доработке
	БПСервер.ОповеститьОДоработке(Объект.БизнесПроцесс, Объект.Исполнитель, Комментарий);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтменаЗаявки(Команда)
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("отменить данную заявку") Тогда
		Возврат;
	КонецЕсли; 
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
	    Возврат;	
	КонецЕсли;
	
	//Если Записать() Тогда
		Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
			//ВыполненоСервер(0, 0);
			БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, Команда.Имя, ПолучитьСтруктуруРеквизитовФормы());
			ОповеститьОбИзменении(Объект.Ссылка);
			Оповестить("ОбновитьСписокЗадач");
			Закрыть();
		КонецЕсли;
	//КонецЕсли;

КонецПроцедуры
     
&НаКлиенте
Процедура ЗаявкаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	БюджетныйНаКлиенте.УниверсальноеВыполнениеКоманды(Объект.Заявка, "");
	
КонецПроцедуры

&НаСервере
Процедура Печать(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.Печать(ТабДок, ПараметрКоманды, "ПечатьБезНалБух");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПлатежки(Команда)
	ОбработкаПлатежек = ПолучитьФорму("Обработка.Д_ЗаявкиВПлатежки.Форма");
	ОбработкаПлатежек.Заявка = Объект.Заявка;
	ОбработкаПлатежек.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДвиженияДС(Команда)
	ОбработкаПлатежек = ПолучитьФорму("Обработка.Д_ЗаявкиВПлатежки.Форма");
	ОбработкаПлатежек.Заявка = Объект.Заявка;
	ОбработкаПлатежек.НомерСправочники = Объект.Номер;
	ОбработкаПлатежек.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	РеквизитыЗаявки = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Заявка, "Файл, Автор");
	АвторДокумента = РеквизитыЗаявки.Автор;
	
	ЭтаФорма.ЗаблокироватьДанныеФормыДляРедактирования();
	
	БПСервер.ЗаписатьДействиеПользователяВЛог(Объект.Ссылка, "ПриОткрытии");
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПлатежки(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	ТабДок = Новый ТабличныйДокумент;
	
	ПечатьПлатежкиНаСервере(ТабДок, Объект.Заявка);

	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Истина;
	ТабДок.ОтображатьГруппировки = Истина;
	ТабДок.АвтоМасштаб = Истина;
	ФормаПечати = ПолучитьФорму("ОбщаяФорма.ФормаПечатиДокумента");
	ФормаПечати.ТабДок = ТабДок;
	ФормаПечати.Открыть();

КонецПроцедуры

&НаКлиенте
Функция ПроверитьКомментарий()

	Если ПустаяСтрока(Комментарий) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Необходимо заполнить комментарий!";
		Сообщение.Поле = "Комментарий";
		Сообщение.Сообщить();
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции


&НаСервере
Процедура ПечатьПлатежкиНаСервере(ТабДок, ПараметрКоманды)
	Документы.Д_ЗаявкаНаОплату.ПечатьПлатежки(ТабДок, ПараметрКоманды);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытьФормуСправочники" Тогда
		Модифицированность = Ложь;
		ПриСозданииНаСервере(Ложь, Истина);
		//Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьСтруктуруРеквизитовФормы()
	Возврат БПСервер.ПолучитьСтруктуруРеквизитовФормы(ЭтаФорма);
КонецФункции

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	БПСервер.ЗаписатьДействиеПользователяВЛог(Объект.Ссылка, "ПослеЗаписи");
КонецПроцедуры

//Функция проверяет наличие созданных на основании заявки платежных документов. 
//	0: Сумма созданных документов соответствует заявке
//	1: Не найдено связанных с завкой платежных документов
//	2: Сумма созданных документов меньше заявленной
&НаСервереБезКонтекста
Функция ПроверитьНаличиеПлатежныхДокументовНал(Заявка)
	
	Запрос = новый Запрос;      
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_РК.Ссылка,
	               |	УЧ_РК.Сумма КАК СуммаДокумента
	               |ИЗ
	               |	Документ.УЧ_РК КАК УЧ_РК
	               |ГДЕ
	               |	УЧ_РК.ДокОснование = &Заявка
	               |	И НЕ УЧ_РК.ПометкаУдаления";
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Если Выгрузка.Количество() = 0 Тогда
		Возврат 1
	ИначеЕсли Выгрузка.Итог("СуммаДокумента") < Заявка.СуммаДокумента Тогда
		Возврат 2
	Иначе 
		Возврат 0
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьНаличиеПлатежныхДокументовБезНал(Заявка)
	
	МассивСтрокБезПП = Новый Массив;
	
	Запрос = новый Запрос;      
	Запрос.УстановитьПараметр("Заявка", Заявка);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПлатежноеПоручениеСтрокиЗаявкиНаОплату.УИДСтрокиДокОснования
	               |ИЗ
	               |	Документ.ПлатежноеПоручение.СтрокиЗаявкиНаОплату КАК ПлатежноеПоручениеСтрокиЗаявкиНаОплату
	               |ГДЕ
	               |	ПлатежноеПоручениеСтрокиЗаявкиНаОплату.ДокОснование = &Заявка
	               |	И НЕ ПлатежноеПоручениеСтрокиЗаявкиНаОплату.Ссылка.ПометкаУдаления";
				   
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаЗаявки Из Заявка.ЗаявкаБезнал Цикл
		
		Если Выгрузка.Найти(СтрокаЗаявки.УИДСтроки, "УИДСтрокиДокОснования") = Неопределено И Не СтрокаЗаявки.ОтменаОплаты Тогда
			МассивСтрокБезПП.Добавить(СтрокаЗаявки.НомерСтроки);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивСтрокБезПП;
		
КонецФункции

&НаКлиенте
Процедура ЗакрытьЗаявку(Команда)
	
	Если НЕ БюджетныйНаКлиенте.СогласоватьБизнесПроцесс("закрыть данную заявку") Тогда
		Возврат;
	КонецЕсли; 
	Если БюджетныйНаКлиенте.ЗадачаВыполнена(Объект) Тогда
		Возврат;	
	КонецЕсли;
	
	ЗаявкаЗакрыта = Истина;
	
	Если Не БПСервер.ПроверкаЗадачи(Объект.Ссылка) Тогда
		БПСервер.ВыполнитьКомандуЗадачиБП(Объект.Ссылка, "ЗаявкаОплачена", ПолучитьСтруктуруРеквизитовФормы());
		ОповеститьОбИзменении(Объект.Ссылка);
		Оповестить("ОбновитьСписокЗадач");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры
